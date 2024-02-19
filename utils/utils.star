constants = import_module("/constants/constants.star")


def get_package_config_from_args(mongo_config, backend_service_config):
    mongo_config = fill_mongo_config(mongo_config)

    backend_service_config = fill_backend_service_config(backend_service_config)

    return struct(
        mongo_config=mongo_config,
        backend_service_config=backend_service_config,
    )


def fill_mongo_config(mongo_config):
    default_mongo_config = constants.DEFAULT_MONGO_CONFIG

    if mongo_config == None:
        return default_mongo_config

    if mongo_config["name"] == "" or mongo_config["name"] == " ":
        mongo_config["name"] = default_mongo_config["name"]
    if mongo_config["image"] == "" or mongo_config["image"] == " ":
        mongo_config["image"] = default_mongo_config["image"]
    if mongo_config["root_user"] == "" or mongo_config["root_user"] == " ":
        mongo_config["root_user"] = default_mongo_config["root_user"]
    if mongo_config["root_password"] == "" or mongo_config["root_password"] == " ":
        mongo_config["root_password"] = default_mongo_config["root_password"]
    if mongo_config["backend_db_name"] == "" or mongo_config["backend_db_name"] == " ":
        mongo_config["backend_db_name"] = default_mongo_config["backend_db_name"]
    if mongo_config["backend_user"] == "" or mongo_config["backend_user"] == " ":
        mongo_config["backend_user"] = default_mongo_config["backend_user"]
    if (
        mongo_config["backend_password"] == ""
        or mongo_config["backend_password"] == " "
    ):
        mongo_config["backend_password"] = default_mongo_config["backend_password"]

    return mongo_config


def fill_backend_service_config(backend_service_config):
    default_backend_service_config = constants.DEFAULT_BACKEND_SERVICE_CONFIG

    if backend_service_config == None:
        return default_backend_service_config

    if (
        backend_service_config["http_public_port"] == ""
        or backend_service_config["http_public_port"] == " "
    ):
        backend_service_config["http_public_port"] = default_backend_service_config[
            "http_public_port"
        ]

    return backend_service_config
