_env() {
    export K8S_CONNECT_NO_PS_CHANGE=yes
    export K8S_CONNECT_QUIET=yes
    [ -e quickstart.ipynb ] && echo "Notebooks directory detected, changing directory to project root" && cd ..
    ! local output=`source switch_environment.sh "$@" 2>/dev/stdout` \
        && echo "${output}" && return 1
    echo "$@: connected"
    return 0
}

helm_upgrade_external_chart() {
    ! local output=$(./helm_upgrade_external_chart.sh "$@" --dry-run) \
        && echo "${output}" && return 1
    ! ./helm_upgrade_external_chart.sh "$@" && return 1
    echo waiting for pod...
    local i=0
    while true; do
        i=`expr $i + 1`
        [ "$i" == "6" ] && echo timeout waiting for pod to enter Running phase && return 1
        sleep 3
        kubectl get pods -l app="${1}" -o json | python -c "
import sys, json, yaml, time
items = json.load(sys.stdin)['items']
assert len(items) == 1
if items[0]['status']['phase'] == 'Running':
    exit(0)
else:
    print(f'phase = {items[0][\"status\"][\"phase\"]}')
    exit(1)" \
        && echo "${1}" pod is running && return 0
    done
}

get_pod_status_log() {
    kubectl get pod $@ -o json | python -c "
import sys, json, yaml
items = json.load(sys.stdin)['items']
assert len(items) == 1
print(yaml.dump(items[0]['status'], default_flow_style=False))
    " && kubectl logs $@
}
