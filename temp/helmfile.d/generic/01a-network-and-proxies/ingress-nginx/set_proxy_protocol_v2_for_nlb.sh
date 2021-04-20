#!/bin/bash
export EKS_VPC_ID="${EKS_VPC_ID:=vp-xxxx}"
export AWS_REGION="${AWS_REGION:=us-east-1}"
export AWS_ROLE_ARN="${AWS_ROLE_ARN:=yyyyyy}"

role_arn=$AWS_ROLE_ARN
session_name="tf-cloud-`date +%Y%m%d`"

echo 'Assuming role...'
sts=( $(
    aws sts assume-role \
    --role-arn "$role_arn" \
    --role-session-name "$session_name" \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text
) )

export AWS_ACCESS_KEY_ID=${sts[0]}
export AWS_SECRET_ACCESS_KEY=${sts[1]}
export AWS_SESSION_TOKEN=${sts[2]}

# Get all the ARNs for the NLBs, Filter by VPC
load_balancer_arn_for_nginx_ingress=''
all_nlbs_arns_filter_by_vpc=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?VpcId==\`${EKS_VPC_ID}\`]|[].LoadBalancerArn" --output text --region=${AWS_REGION} | tr -d '[],')

for _nlb in $all_nlbs_arns_filter_by_vpc; do
  _filter_tags_for_nlb=($(aws elbv2 describe-tags --resource-arns $_nlb --region=${AWS_REGION} --query "TagDescriptions[*].Tags[?Key == 'kubernetes.io/service-name' && contains(Value, 'ingress-nginx/nginx-ingress-nginx-controller')]" | tr -d '[],'))

  if [ ${#_filter_tags_for_nlb[@]} -eq 0 ]; then
    echo "Skip - tags not matched for: $_nlb"
  else
    echo "Tags Matched - ingress-nginx: $_nlb"
    load_balancer_arn_for_nginx_ingress=$_nlb
  fi
done

if [ -z "$load_balancer_arn_for_nginx_ingress" ]; then
      echo "No Matching NLB found !!"
else
	# Get Target Groups ARNs
	gettargetGroupsArn=$(aws elbv2 describe-target-groups --load-balancer-arn $load_balancer_arn_for_nginx_ingress --query 'TargetGroups[*].TargetGroupArn' --output text --region=${AWS_REGION} | tr -d '[],')
	# Update the proxy_protocol attribute
	for targetGroupArn in $gettargetGroupsArn; do
	  echo "Updating the proxy_protocol_v2 attribute for: $load_balancer_arn_for_nginx_ingress"
		aws elbv2 modify-target-group-attributes --target-group-arn $targetGroupArn --attributes Key=proxy_protocol_v2.enabled,Value=true --output text --region=${AWS_REGION}
	done
fi