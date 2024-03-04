nginx = import_module("github.com/kurtosis-tech/nginx-package/main.star")

NGINX_SERVICE_NAME = "nginx"
NGINX_PORT_NUMBER = 80
NGINX_ROOT_DIRPATH = "/var/www/html"
NGINX_PORT_ID = "http"
NGINX_IMAGE_NAME = "nginx:latest"

def run(plan, frontend_service, backend_service):

    # upload Nginx config template
    nginx_default_conf_contents = read_file(src="./template/default.conf")
    
    template_data = {
        "NginxPortNumber":NGINX_PORT_NUMBER,
        "NginxRootFolder":NGINX_ROOT_DIRPATH,
        "FrontendHost":frontend_service.hostname,
        "FrontendPort":frontend_service.ports['http'].number,
        "BackendHost":backend_service.hostname,
        "BackendPort":backend_service.ports['http'].number,
    }

    nginx_conf_file_artifact_name = plan.render_templates(
        config={
            "default.conf": struct(
                template=nginx_default_conf_contents,
                data=template_data,
            ),
        },
        name="nginx_config",
    )
    
    nginx_args = {
        "name":NGINX_SERVICE_NAME,
        "image":NGINX_IMAGE_NAME,
        "config_files_artifact":nginx_conf_file_artifact_name,
        "root_dirpath":NGINX_ROOT_DIRPATH,
        "root_file_artifact_name":"",
        "port_id":NGINX_PORT_ID,
        "port_number":NGINX_PORT_NUMBER
    }

    nginx.run(
        plan,
        args= nginx_args,
    )
