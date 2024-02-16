constants = import_module("/constants/constants.star")


def get_package_config_from_args(args):
    mongo_config = validate_mongo_config(args["mongo_config"])

    backend_service_config = fill_backend_service_config(args["backend_service_config"])

    return struct(
        mongo_config=mongo_config,
        backend_service_config=backend_service_config,
    )


def validate_mongo_config(mongo_config):
    if mongo_config["name"] == "" or mongo_config["name"] == " ":
        fail(
            "The Mongo's service name is empty. Please configure a valid service name."
        )
    if mongo_config["image"] == "" or mongo_config["image"] == " ":
        fail(
            "The Mongo's service container image is empty. Please configure a valid container image for the Mongo service."
        )
    if mongo_config["root_user"] == "" or mongo_config["root_user"] == " ":
        fail("The Mongo's root user is empty. Please configure a root user.")
    if mongo_config["root_password"] == "" or mongo_config["root_password"] == " ":
        fail(
            "The Mongo's root user password is empty. Please configure a root user password."
        )
    if mongo_config["backend_db_name"] == "" or mongo_config["backend_db_name"] == " ":
        fail(
            "The Mongo's backend service database name is empty. Please configure a database name for the backend Mongo db."
        )
    if mongo_config["backend_user"] == "" or mongo_config["backend_user"] == " ":
        fail(
            "The Mongo's user name for the backend service is empty. Please configure a database user name for the backend service."
        )
    if (
        mongo_config["backend_password"] == ""
        or mongo_config["backend_password"] == " "
    ):
        fail(
            "The Mongo's password for the backend service is empty. Please configure a database password for the backend service."
        )

    return mongo_config


def fill_backend_service_config(backend_service_config):
    backend_http_public_port = backend_service_config.get(
        "http_public_port", constants.DEFAULT_BACKEND_HTTP_PUBLIC_PORT
    )
    backend_service_config["http_public_port"] = backend_http_public_port

    return backend_service_config
