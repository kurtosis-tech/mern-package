def run(plan):
    # upload frontend files
    frontend_files = plan.upload_files(
        src="./files/",
        name="frontend-files",
    )

    service_config = ServiceConfig(
        image="node:16.14.2",
        files={
            "/frontend/files": Directory(
                artifact_names=[frontend_files],
            ),
        },
        entrypoint=["sh", "-c"],
        cmd=[
            "cd /frontend/files/ && npm i && npm start"
        ],
        ports={
            "http": PortSpec(
                number=3000,
                transport_protocol="TCP",
                application_protocol="http",
            ),
        },
    )

    frontend_service = plan.add_service(
        name="react-frontend",
        config=service_config,
    )

    return frontend_service
