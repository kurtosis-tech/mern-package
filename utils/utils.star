constants = import_module("/constants/constants.star")

def get_package_config_from_args(args):

    backend_service_config = args["backend_service_config"]
    backend_http_public_port = backend_service_config.get("http_public_port", constants.DEFAULT_BACKEND_HTTP_PUBLIC_PORT)
    backend_service_config["http_public_port"] = backend_http_public_port

    return struct(
        mongo_config = args["mongo_config"],
        backend_service_config = backend_service_config,
    )
    