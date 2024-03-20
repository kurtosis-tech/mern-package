def run(plan, mongodb_url, backend_http_public_port):
    # upload server files
    server_files = plan.upload_files(
        src="./files/",
        name="server-files",
    )

    service_config = ServiceConfig(
        image="node:16.14.2",
        files={
            "/server/files": Directory(
                artifact_names=[server_files],
            ),
        },
        entrypoint=["sh", "-c"],
        cmd=["cd /server/files/ && npm i && npm start"],
        ports={
            "http": PortSpec(
                number=8080,
                transport_protocol="TCP",
                application_protocol="http",
            ),
        },
        env_vars = {
            "MONGO_URI": mongodb_url,
        },
    )

    backend_service = plan.add_service(
        name="express-backend",
        config=service_config,
    )

    return backend_service
