# Creating an NGINX Ingress Controller with Network Load Balancer (NLB) with TLS Termination at Load Balancer level
This configuration lets you provide a TLS certificate from AWS Certificate Manager. It handles TLS termination, as well as redirects from http to https protocol.

Note : NLB support is not complete in Kubernetes (https://github.com/kubernetes/kubernetes/issues/57250). 
       To obtain a working setup it is necessary to apply a post-install script using kubectl and the AWS CLI.

1. The ingress-nginx chart install is automated. 
2. Apply the following post-install script to enable Proxy Protocol v2 on the NLB target groups. You will need:
    - A valid Kubernetes context pointing to the cluster you installed ingress-nginx in.
    - A valid AWS context to use the CLI.

```
# For enabling proxy-protocol 
# Open Issue: https://github.com/kubernetes/kubernetes/issues/57250

#!/bin/bash -eu
export AWS_REGION="us-east-1"
export AWS_PROFILE="gen3preprodacc"

hostname=$(kubectl get -n ingress-nginx services nginx-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')
loadBalancerArn=$(aws elbv2 describe-load-balancers  --query "LoadBalancers[?DNSName==\`$hostname\`].LoadBalancerArn"  --output text --region=${AWS_REGION})
targetGroupsArn=($(aws elbv2 describe-target-groups --load-balancer-arn $loadBalancerArn --query 'TargetGroups[*].TargetGroupArn' --output text --region=${AWS_REGION} | tr -d '[],'))

for targetGroupArn in $targetGroupsArn; do
  aws elbv2 modify-target-group-attributes --target-group-arn $targetGroupArn --attributes Key=proxy_protocol_v2.enabled,Value=true --output text --region=${AWS_REGION}
done
```
It is also possible to use the AWS Console to enable proxy protocol.