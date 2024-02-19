utils = import_module("/utils/utils.star")
database = import_module("/database/database.star")
express_backend = import_module("/backend/backend.star")
frontend = import_module("/frontend/frontend.star")


def run(plan, mongo_config = None, backend_service_config = None):
    """
    Starts this MERN example application.

    Args:
        mongo_config (json): The Mongo db configs to start the db service.
        backend_service_config (json): The configs to start the backend service.
    """

    # get configurations
    package_config = utils.get_package_config_from_args(mongo_config, backend_service_config)

    # run the application's database
    mongodb_url = database.run(plan, package_config.mongo_config)

    be_http_public_port = package_config.backend_service_config["http_public_port"]

    # run the application's backend service
    backend_service = express_backend.run(plan, mongodb_url, be_http_public_port)

    # run the application's frontend service
    frontend.run(plan, backend_service, be_http_public_port)
