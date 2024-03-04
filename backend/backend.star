def run(plan, mongodb_url, backend_http_public_port):
    # upload server files
    server_files = plan.upload_files(
        src="./files/",
        name="server-files",
    )

    # upload template
    template_file_contents = read_file(src="./template/index.js")

    template_data = {
        "MongoURI": mongodb_url,
    }

    server_constants = plan.render_templates(
        config={
            "index.js": struct(
                template=template_file_contents,
                data=template_data,
            ),
        },
        name="server-constants",
    )

    service_config = ServiceConfig(
        image="node:16.14.2",
        files={
            "/server/files": Directory(
                artifact_names=[server_files],
            ),
            "/server/constants": server_constants,
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
    )

    backend_service = plan.add_service(
        name="express-backend",
        config=service_config,
    )

    return backend_service
