utils = import_module("/utils/utils.star")
database = import_module("/database/database.star")
express_backend = import_module("/backend/backend.star")
frontend = import_module("/frontend/frontend.star")


def run(plan, mongo_config=None, backend_service_config=None):
    """
    Starts this MERN example application.

    Args:
        mongo_config (json): The Mongo db configs to start the db service. If empty, the database will start with default settings.
            - name (string): the name of the Mongo db service (default: mongo-db)
            - image (string): the container image and label used to create the service (default: mongo:6.0.5)
            - root_user (string): the Mongo's root user name (default: root)
            - root_password (string): the Mongo's root user password (default: root-password)
            - backend_db_name (string): the name of the backend service's db (default: backend-db)
            - backend_user (string): the name of user created for managing the backend service's db (default: backend-user)
            - backend_password (string): the name of user created for managing the backend service's db (default: backend-password)
            ```
            {
                # the name of the Mongo db service (default: mongo-db)
                "name": "mongo-db",

                # the container image and label used to create the service (default: mongo:6.0.5)
                "image": "mongo:6.0.5",

                # the Mongo's root user name (default: root)
                "root_user": "root",

                # the Mongo's root user password (default: root-password)
                "root_password": "root-password",

                # the name of the backend service's db (default: backend-db)
                "backend_db_name": "backend-db",

                # the name of user created for managing the backend service's db (default: backend-user)
                "backend_user": "backend-user",

                # the name of user created for managing the backend service's db (default: backend-password)
                "backend_password": "backend-password"
            }
            ```
        backend_service_config (json): The configs to start the backend service. If empty, the database will start with default settings.
            - http_public_port (int): the name of the Mongo db service (default: 65535)
            ```
            {
                # the name of the Mongo db service (default: 65535)
                "http_public_port": 65535
            }
            ```
    """

    # get configurations
    package_config = utils.get_package_config_from_args(
        mongo_config, backend_service_config
    )

    # run the application's database
    mongodb_url = database.run(plan, package_config.mongo_config)

    be_http_public_port = package_config.backend_service_config["http_public_port"]

    # run the application's backend service
    backend_service = express_backend.run(plan, mongodb_url, be_http_public_port)

    # run the application's frontend service
    frontend.run(plan, backend_service, be_http_public_port)
