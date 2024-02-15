utils = import_module("/utils/utils.star")
mongodb = import_module("github.com/kurtosis-tech/mongodb-package/main.star")
express_backend = import_module("/backend/backend.star")
frontend = import_module("/frontend/frontend.star")

def run(plan, args):

    # Creating the database

    package_config = utils.get_package_config_from_args(args)

    mongo_service_name = package_config.mongo_config["name"]
    mongo_user_name = package_config.mongo_config["root_user"]
    mongo_user_password = package_config.mongo_config["root_password"]
    mongo_backend_db_name = package_config.mongo_config["backend_db_name"]
    mongo_backend_user = package_config.mongo_config["backend_user"]
    mongo_backend_password = package_config.mongo_config["backend_password"]

    mongodb_module_output = mongodb.run(plan, package_config.mongo_config)
    mongodb_service_port = mongodb_module_output.service.ports['mongodb'].number


    # create backend user and db
    command_create_user = "db.getSiblingDB('%s').createUser({user:'%s', pwd:'%s', roles:[{role:'readWrite',db:'%s'}]});" % (
        mongo_backend_db_name, mongo_backend_user, mongo_backend_password, mongo_backend_db_name
    )
    exec_create_user = ExecRecipe(
        command = [
            "mongosh",
            "-u",
            mongo_user_name,
            "-p",
            mongo_user_password,
            "-eval",
            command_create_user
        ],
    )
    plan.wait(
        service_name = mongodb_module_output.service.name,
        recipe = exec_create_user,
        field = "code",
        assertion = "==",
        target_value = 0,
        timeout = "30s",
    )

    mongodb_url = "mongodb://%s:%s@%s:%d/%s" % (
        mongo_backend_user,
        mongo_backend_password,
        mongo_service_name,
        mongodb_service_port,
        mongo_backend_db_name,
    )
    # DB creation finished

    be_http_public_port = package_config.backend_service_config["http_public_port"]

    backend_service = express_backend.run(plan, mongodb_url, be_http_public_port)

    frontend.run(plan, backend_service, be_http_public_port)
