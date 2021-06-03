# SkillfactOrc
1. terra1.tf - разворачиваем машины в яндекс облаке(дока в яндексе понятнее, да и в терраформе норм. Грусть- нельзя юзать пересенные в описании s3)
2. plan.log - вывод terraform plan
3. apllay.log - вывод terraform applay
4. k8sBOTH.sh - скрипт для запуска на всех машинах участниках кластера
5. Ниже команды для запуска на мастере:

   sudo su -
   
   kubeadm init ( sudo kubeadm --pod-network-cidr=10.244.0.0/16 init)-если юзать flannel  !!! из ответа выловить join
   
   exit
   
   mkdir -p $HOME/.kube
   
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   
   sudo chown $(id -u):$(id -g) $HOME/.kube/config
   
   kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
   
   kubectl get pods  --all-namespaces   - проверить.
   
   Если не flannel:
   
   kubeadm init
   
   kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" - пока не понял что это,но работает.
  
6. join - на воркере(в ответе на init)
7. kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml  - dashbord
8. dasbord - доп команды чтобы дашборт заработал.(в кубере плохая документация - ничерта не понятно)
9. Бросаем порты через тунель пути(как в видосе только тунель доп настройка в меню) и ловим дашборт на http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
10. k8sDash.png - скрин с дашборда
