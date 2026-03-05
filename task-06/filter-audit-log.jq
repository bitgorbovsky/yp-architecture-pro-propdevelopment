[
    "kubernetes-admin",
    "system:serviceaccount:kube-system:daemon-set-controller"
] as $ignoredUsers |
.user.username as $user |
.impersonatedUser?.username as $effectiveUser |
select(
    (
        # Убираем события от системных пользователей
        $ignoredUsers | index($user) == null
    ) and (
        # Ищем обращения к секретам
        (.objectRef.resource == "secrets" and .verb == "get") or

        # Ищем подозрительные действия с pod'ами
        (.objectRef.resource == "pods" and (
            # Запуск pod'ов c завышенными привилегиями
            (
                .requestObject.spec.containers != null and
                .requestObject.spec.containers[].securityContext.privileged == true
            ) or

            # Выполнение команд в pod'ах
            .objectRef.subresource == "exec"
        )) or

        # Ищем подозрительные действия с системой авторизации
        (
            .objectRef.resource == "rolebindings"
        )
    )
)
