def run(plan):
    # upload frontend files
    frontend_files = plan.upload_files(
        src="./files/",
        name="frontend-files",
    )

    service_config = ServiceConfig(
        image=ImageBuildSpec(
            image_name="kurtosistech/mern-package-frontend",
            build_context_dir="/frontend/files",
        ),
        files={
            "/frontend/files": Directory(
                artifact_names=[frontend_files],
            ),
        },
        entrypoint=["sh", "-c"],
        cmd=[
            "cd /frontend/files/ && npm i && npm run build && npm install -g serve && serve -s build"
        ],
        ports={
            "http": PortSpec(
                number=3000,
                transport_protocol="TCP",
                application_protocol="http",
                wait="2m"
            ),
        },
        env_vars = {
            # we set this in order to use the window.location.port value as the default value
            # this way the WS call will go directly to the gateway's service and proxy it to the FE
            # more here: https://create-react-app.dev/docs/advanced-configuration/
            "WDS_SOCKET_PORT": "0",
        },
    )

    frontend_service = plan.add_service(
        name="react-frontend",
        config=service_config,
    )

    return frontend_service
