mongodb = import_module("github.com/kurtosis-tech/mongodb-package/main.star")
express_backend = import_module("/backend/backend.star")

lib = import_module("./lib/lib.star")


def run(plan, args):

    # Creating the database

    mongo_service_name = args["mongo_config"]["name"]
    mongo_user_name = args["mongo_config"]["root_user"]
    mongo_user_password = args["mongo_config"]["root_password"]
    mongo_backend_db_name = args["mongo_config"]["backend_db_name"]
    mongo_backend_user = args["mongo_config"]["backend_user"]
    mongo_backend_password = args["mongo_config"]["backend_password"]

    mongodb_module_output = mongodb.run(plan, args["mongo_config"])
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

    express_backend.run(plan, mongodb_url)
