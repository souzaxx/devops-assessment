cluster:
	k3d cluster create sandman \
	    -p 8080:80@loadbalancer \
	    -v /etc/machine-id:/etc/machine-id:ro \
	    -v /var/log/journal:/var/log/journal:ro \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    --k3s-server-arg '--no-deploy=traefik' \
	    --agents 0
