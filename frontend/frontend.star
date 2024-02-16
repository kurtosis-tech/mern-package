def run(plan, backend_service, backend_http_public_port):
    # upload frontend files
    frontend_files = plan.upload_files(
        src="./files/",
        name="frontend-files",
    )
    backend_url = "http://localhost:{}".format(backend_http_public_port)

    service_config = ServiceConfig(
        image="node:16.14.2",
        files={
            "/frontend/files": Directory(
                artifact_names=[frontend_files],
            ),
        },
        entrypoint=["sh", "-c"],
        cmd=[
            "cd /frontend/files/ && echo \"export const BACKEND_URL = '{}' \" > ./src/constants/index.js && npm i && npm start".format(
                backend_url
            )
        ],
        ports={
            "http": PortSpec(
                number=3000,
                transport_protocol="TCP",
                application_protocol="http",
                wait=None,
            ),
        },
        env_vars={
            "BACKEND_URL": backend_url,
        },
    )

    plan.add_service(
        name="react-frontend",
        config=service_config,
    )
