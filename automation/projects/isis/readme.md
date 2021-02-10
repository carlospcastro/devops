### **Isis Project** 

Install the following stack in a automated way

* Prometheus
* Grafana
* Create DNS record

## Environment
* Azure

## Tools
* Kubernetes
* Helm

First of, we need to create our K8S cluster and to do that you can find the step by step in another post that I made:

[Azure Kubernetes with Terraform](https://carlospcastro.com/2021/01/31/azure-kubernetes-with-terraform/)

After create the AKS we gonna start installing the applications using Helm. To install Helm, it will depends on your local system and how you are used to install tools, please check this link below:

[Installing Helm](https://helm.sh/docs/intro/install/)

We gonna start with Prometheus and Grafana, in order to install those software we gonna use [Kube Prometheus Stack Project](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) .

Add the following repositories:

```bash
➜  devops git:(v0.1) ✗ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories

➜  devops git:(v0.1) ✗ helm repo add stable https://charts.helm.sh/stable
"stable" has been added to your repositories

➜  devops git:(v0.1) ✗ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈

➜  devops git:(v0.1) ✗ helm repo list
NAME                	URL
prometheus-community	https://prometheus-community.github.io/helm-charts
stable              	https://charts.helm.sh/stable
➜  devops git:(v0.1) ✗
```

The values file that I'm using is in:

```bash
https://github.com/carlospcastro/devops/tree/main/helm/kube-prometheus-stack
```

Install Kube Prometheus Stack helm chart

```bash
➜  kube-prometheus-stack git:(v0.1) helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --values values.yaml
Release "prometheus" does not exist. Installing it now.
NAME: prometheus
LAST DEPLOYED: Tue Feb  9 20:42:05 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace default get pods -l "release=prometheus"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
➜  kube-prometheus-stack git:(v0.1)
```

```bash
➜  kube-prometheus-stack git:(v0.1) helm list
NAME      	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART                       	APP VERSION
prometheus	default  	1       	2021-02-09 20:42:05.827997 +0100 CET	deployed	kube-prometheus-stack-13.6.0	0.45.0
➜  kube-prometheus-stack git:(v0.1) kubectl get pod
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          2m14s
prometheus-grafana-5c6f6d895-lmzvj                       2/2     Running   0          2m17s
prometheus-kube-prometheus-operator-7c778f99bf-cphxh     1/1     Running   0          2m17s
prometheus-kube-state-metrics-6858fbf46f-nptz4           1/1     Running   0          2m17s
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   1          2m13s
prometheus-prometheus-node-exporter-xqslz                1/1     Running   0          2m17s
➜  kube-prometheus-stack git:(v0.1)
```

Grafana Port forward

```bash
➜  kube-prometheus-stack git:(v0.1) kubectl port-forward prometheus-grafana-5c6f6d895-lmzvj 3000:3000
Forwarding from 127.0.0.1:3000 -> 3000
Forwarding from [::1]:3000 -> 3000
```

user: `admin`

pass: `prom-operator`

![https://carlospcastro.com/wp-content/uploads/2021/02/grafana01-1024x576.png](https://carlospcastro.com/wp-content/uploads/2021/02/grafana01-1024x576.png)

Prometheus Port forward

```bash
➜  kube-prometheus-stack git:(v0.1) kubectl port-forward prometheus-prometheus-kube-prometheus-prometheus-0 9000:9000
Forwarding from 127.0.0.1:9000 -> 9000
Forwarding from [::1]:9000 -> 9000
```

![https://carlospcastro.com/wp-content/uploads/2021/02/prometheus01-2-1024x469.png](https://carlospcastro.com/wp-content/uploads/2021/02/prometheus01-2-1024x469.png)

## External DNS

In order to create our DNS record automatically we gonna use [External DNS](https://github.com/kubernetes-sigs/external-dns) helm chart. 

In Azure side you need to have Service Principal and DNS Domain ready to go. You can find how create it in the External DNS page (link above) or if you want one specific tutorial on it here, let me know in the comment section. 

Install an ingress controller. I have choose `traefik`, just because I wanted try another one comparing with the External DNS documentation, they are using NGINX.

```bash
➜  ingress git:(v0.1) ✗ helm repo add traefik https://helm.traefik.io/traefik
"traefik" has been added to your repositories
➜  ingress git:(v0.1) ✗ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "traefik" chart repository
...Successfully got an update from the "prometheus-community" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
```

```bash
➜  ingress git:(v0.1) ✗ helm install traefik traefik/traefik
NAME: traefik
LAST DEPLOYED: Tue Feb  9 23:41:54 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

Clone the repository

```bash
https://github.com/carlospcastro/devops/tree/main/helm/external-dns
```

Install External DNS helm chart

```bash
➜  external-dns git:(v0.1) ✗ helm  upgrade --install  externaldns . -f values.yaml
Release "externaldns" does not exist. Installing it now.
NAME: externaldns
LAST DEPLOYED: Tue Feb  9 23:08:30 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

Install Ingress helm chart

```bash
➜  ingress git:(v0.1) ✗ helm upgrade --install ingress -f grafana.yaml .
Release "ingress" does not exist. Installing it now.
NAME: ingress
LAST DEPLOYED: Tue Feb  9 23:28:31 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

Check the ingress and service

```bash
➜  helm git:(v0.1) ✗ kubectl get ingress
NAME      CLASS    HOSTS                       ADDRESS   PORTS   AGE
grafana   <none>   grafana.carlospcastro.com             80      34m

➜  helm git:(v0.1) ✗ kubectl get svc grafana-internal
NAME               TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
grafana-internal   LoadBalancer   10.0.202.6   10.240.0.5    3000:31572/TCP   39m
```

Then you can also check if the External DNS has created the DNS record

```bash
time="2021-02-09T22:45:32Z" level=info msg="Updating CNAME record named 'grafana' to 'grafana.carlospcastro.com' for Azure Private DNS zone 'carlospcastro.com'."                                                                       
time="2021-02-09T22:45:32Z" level=error msg="Failed to update CNAME record named 'grafana' to 'grafana.carlospcastro.com' for Azure Private DNS zone 'carlospcastro.com': privatedns.RecordSetsClient#CreateOrUpdate: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code=\"BadRequest\" Message=\"The Cname record cannot point at the same resource record.\""                                       
time="2021-02-09T22:45:32Z" level=info msg="Updating TXT record named 'grafana' to '\"heritage=external-dns,external-dns/owner=isis,external-dns/resource=ingress/default/grafana\"' for Azure Private DNS zone 'carlospcastro.com'."
time="2021-02-09T22:46:32Z" level=info msg="Updating A record named 'grafana' to '10.240.0.5' for Azure Private DNS zone 'carlospcastro.com'."                                                                                          
time="2021-02-09T22:46:32Z" level=info msg="Updating TXT record named 'grafana' to '\"heritage=external-dns,external-dns/owner=isis,external-dns/resource=service/default/grafana-internal\"' for Azure Private DNS zone 'carlospcastro.com'."
```

![https://carlospcastro.com/wp-content/uploads/2021/02/dns01-1-1024x243.png](https://carlospcastro.com/wp-content/uploads/2021/02/dns01-1-1024x243.png)

```bash
➜  helm git:(v0.1) helm list
NAME       	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART                       	APP VERSION
externaldns	default  	2       	2021-02-09 23:10:49.455058 +0100 CET	deployed	external-dns-0.1.0          	1.0.0
ingress    	default  	2       	2021-02-09 23:48:51.305535 +0100 CET	deployed	ingress-0.1.0               	1.16.0
prometheus 	default  	1       	2021-02-09 20:42:05.827997 +0100 CET	deployed	kube-prometheus-stack-13.6.0	0.45.0
traefik    	default  	1       	2021-02-09 23:41:54.104816 +0100 CET	deployed	traefik-9.14.2              	2.4.2
```
