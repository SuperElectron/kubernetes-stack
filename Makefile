
install:
	.build/install.sh

pre_run:
	kubectl apply -f 'https://strimzi.io/install/latest?namespace=default' -n default

config_maps:
	kubectl apply -f kafka/config_maps

secrets:
	kubectl apply -f mongo/secrets
	kubectl apply -f ingress/secrets

pv:
	kubectl apply -f cassandra/pv
	kubectl apply -f ams/pv
	kubectl apply -f kafka/pv
	kubectl apply -f mongo/pv

pvc:
	kubectl apply -f cassandra/pvc
	kubectl apply -f ams/pvc
	kubectl apply -f kafka/pvc
	kubectl apply -f mongo/pvc

state:
	kubectl apply -f cassandra/state
	kubectl apply -f ams/state
	kubectl apply -f kafka/state
	kubectl apply -f mongo/state

ingress:
	kubectl apply -f "ingress/ingress.yml"

run: pre_run config_maps secrets pv pvc state ingress
