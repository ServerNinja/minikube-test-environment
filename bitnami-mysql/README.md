# Bitnami-MySQL

Install Command
```
helm upgrade --install mysql -n mysql --create-namespace oci://registry-1.docker.io/bitnamicharts/mysql --values values.yaml
```

Result:
```
helm upgrade --install mysql -n mysql --create-namespace oci://registry-1.docker.io/bitnamicharts/mysql --values values.yaml
Release "mysql" does not exist. Installing it now.
Pulled: registry-1.docker.io/bitnamicharts/mysql:11.0.0
Digest: sha256:64d2f36f7d58d3593550c1502144e7495eec3bd704624b847194ab8bb8227a99
NAME: mysql
LAST DEPLOYED: Thu May 23 14:49:52 2024
NAMESPACE: mysql
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: mysql
CHART VERSION: 11.0.0
APP VERSION: 8.4.0

** Please be patient while the chart is being deployed **

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace mysql

Services:

  echo Primary: mysql.mysql.svc.cluster.local:3306

Execute the following to get the administrator credentials:

  echo Username: root
  MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.4.0-debian-12-r3 --namespace mysql --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash

  2. To connect to primary service (read/write):

      mysql -h mysql.mysql.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - primary.resources
  - secondary.resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
```

Sync mysql secret with reflector
```
kubectl annotate secret mysql -n mysql reflector.v1.k8s.emberstack.com/reflection-allowed="true" --overwrite=true
kubectl annotate secret mysql -n mysql reflector.v1.k8s.emberstack.com/reflection-auto-enabled="true" --overwrite=true
```