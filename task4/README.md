| Роль          | Права роли                 | Группы пользователей     |
|---------------|----------------------------|--------------------------|
| secure-manager | Просмотр и редактирование секретов, политик доступа идр          | Инженеры безопасности   |
| cluster-admin | Управление ресурсами кластера         | Системный администратор |
| cluster-viewer | Просмотр ресурсов кластера | Мониторинг инфраструктуры             |


```bash
# Создаём пользователей, роли, биндинги, обновляем kubectl конфиг
sh ./main.sh
# Тестируем
kubectl config use-context minikube@tech_support
kubectl get secrets
kubectl config use-context minikube@secure_operator
kubectl get secrets
# Восстанавливаем конфиг
kubectl config unset users.cluster_admin
kubectl config unset contexts.minikube@cluster_admin
kubectl config unset users.secure_operator
kubectl config unset contexts.minikube@secure_operator
kubectl config unset users.tech_support
kubectl config unset contexts.minikube@tech_support
```