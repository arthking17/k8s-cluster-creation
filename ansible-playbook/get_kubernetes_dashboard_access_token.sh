#!/bin/sh

curl --request PUT --header "PRIVATE-TOKEN: glpat-RqJrzJQeATHqi392iMgD" "https://gitlab.com/api/v4/groups/38341705/variables/KUBERNETES_DASHBOARD_ACCESS_TOKEN" \
--form "value=$(kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}")"
