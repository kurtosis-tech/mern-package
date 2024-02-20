mongodb = import_module("github.com/kurtosis-tech/mongodb-package/main.star")


def run(
    plan,
    mongo_service_name,
    mongo_image,
    mongo_user_name,
    mongo_user_password,
    mongo_backend_db_name,
    mongo_backend_user,
    mongo_backend_password,
):
    config = {
        "name": mongo_service_name,
        "image": mongo_image,
        "root_user": mongo_user_name,
        "root_password": mongo_user_password,
        "backend_db_name": mongo_backend_db_name,
        "backend_user": mongo_backend_user,
        "backend_password": mongo_backend_password,
    }

    mongodb_module_output = mongodb.run(plan, config)
    mongodb_service_port = mongodb_module_output.service.ports["mongodb"].number

    # create backend user and db
    command_create_user = (
        "db.getSiblingDB('%s').createUser({user:'%s', pwd:'%s', roles:[{role:'readWrite',db:'%s'}]});"
        % (
            mongo_backend_db_name,
            mongo_backend_user,
            mongo_backend_password,
            mongo_backend_db_name,
        )
    )
    exec_create_user = ExecRecipe(
        command=[
            "mongosh",
            "-u",
            mongo_user_name,
            "-p",
            mongo_user_password,
            "-eval",
            command_create_user,
        ],
    )
    plan.wait(
        service_name=mongodb_module_output.service.name,
        recipe=exec_create_user,
        field="code",
        assertion="==",
        target_value=0,
        timeout="30s",
    )

    mongodb_url = "mongodb://%s:%s@%s:%d/%s" % (
        mongo_backend_user,
        mongo_backend_password,
        mongo_service_name,
        mongodb_service_port,
        mongo_backend_db_name,
    )

    return mongodb_url
