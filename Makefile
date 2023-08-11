cluster:
	k3d cluster create sandman \
 		-p 8080:80@loadbalancer \
 		-v /etc/machine-id:/etc/machine-id:ro \
 		-v /var/log/journal:/var/log/journal:ro \
 		-v /var/run/docker.sock:/var/run/docker.sock \
 		--k3s-arg "--disable=traefik@server:0" \
 		--k3s-arg '--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1%@agent:*' \
 		--k3s-arg '--kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%@agent:*' \
 		--k3s-arg '--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1%@server:0' \
 		--k3s-arg '--kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%@server:0' \
 		--agents 0

clean-up:
	k3d cluster delete sandman

install-service:
	kubectl apply -f sample-service.yaml

install-dep:
	helm install --create-namespace --namespace prometheus --version 23.3.0 prometheus prometheus-community/prometheus 
	helm install --create-namespace --namespace ingress ingress bitnami/nginx-ingress-controller
	helm install --create-namespace --namespace jenkins --version 4.5.0 --set controller.additionalPlugins={kubernetes-cli:1.12.0} jenkins jenkinsci/jenkins
