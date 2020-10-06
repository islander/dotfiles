## Kubernetes
# docker-machine completion
PS1='[\u@\h \W$(__docker_machine_ps1 " [%s]")]\$ '
# minikube disable emojis
#export MINIKUBE_IN_STYLE=false
# kubectl completion
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
alias kcd='kubectl config set-context $(kubectl config current-context) --namespace '
## EOF Kubernetes
