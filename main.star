constants = import_module("/constants/constants.star")
database = import_module("/database/database.star")
backend = import_module("/backend/backend.star")
frontend = import_module("/frontend/frontend.star")
gateway = import_module("/gateway/gateway.star")


def run(
    plan,
    mongo_service_name=constants.DEFAULT_MONGO_SERVICE_NAME,
    mongo_image=constants.DEFAULT_MONGO_IMAGE,
    mongo_root_user=constants.DEFAULT_MONGO_ROOT_USER,
    mongo_root_password=constants.DEFAULT_MONGO_ROOT_PASSWORD,
    mongo_backend_db_name=constants.DEFAULT_BACKEND_DB_NAME,
    mongo_backend_db_user=constants.DEFAULT_BACKEND_DB_USER,
    mongo_backend_db_password=constants.DEFAULT_BACKEND_DB_PASSWORD,
    backend_http_public_port=constants.DEFAULT_BACKEND_HTTP_PUBLIC_PORT,
):
    """
    Starts this MERN example application.

    Args:
        mongo_service_name (string): the name of the Mongo db service (default: mongo-db)
        mongo_image (string): the container image and label used to create the service (default: mongo:6.0.5)
        mongo_root_user (string): the Mongo's root user name (default: root)
        mongo_root_password (string): the Mongo's root user password (default: root-password)
        mongo_backend_db_name (string): the name of the backend service's db (default: backend-db)
        mongo_backend_db_user (string): the name of user created for managing the backend service's db (default: backend-user)
        mongo_backend_db_password (string): the name of user created for managing the backend service's db (default: backend-password)
        backend_http_public_port (int): the backend service HTTP public port number which will be used to access to the UI from the host (default: 65535)
    """

    # run the application's database
    mongodb_url = database.run(
        plan,
        mongo_service_name,
        mongo_image,
        mongo_root_user,
        mongo_root_password,
        mongo_backend_db_name,
        mongo_backend_db_user,
        mongo_backend_db_password,
    )

    # run the application's backend service
    backend_service = backend.run(plan, mongodb_url, backend_http_public_port)

    # run the application's frontend service
    frontend_service = frontend.run(plan)

    # run the applications's gateway service
    gateway.run(plan, frontend_service, backend_service)
