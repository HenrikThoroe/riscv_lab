import os
import subprocess
import sys
import re

if __name__ == "__main__":
    components = [
        "execute",
        "instruction_decode",
        "memory_access",
        "instruction_fetch",
        "io",
        "interconnect",
    ]

    comp_versions = {
        "execute": 0,
        "instruction_decode": 0,
        "memory_access": 0,
        "instruction_fetch": 0,
        "io": 0,
        "interconnect": 0,
    }

    if os.path.exists("versions.txt"):
        with open("versions.txt", "r") as f:
            versions = f.readlines()
            versions = [version.strip() for version in versions]

            if len(versions) != len(components):
                print(
                    "Error: versions.txt does not have the same number of lines as components."
                )
                sys.exit(1)

            for version in versions:
                component, ver = version.split(":")

                if component not in components:
                    print(f"Error: {component} is not a valid component.")
                    sys.exit(1)

                comp_versions[component] = float(ver)

    current_versions = {component: comp_versions[component] for component in components}

    for component in components:
        ip_conf_path = f"./{component}/create_ip.tcl"

        if not os.path.exists(ip_conf_path):
            print(f"Error: {ip_conf_path} does not exist.")
            sys.exit(1)

        with open(ip_conf_path, "r") as f:
            content = f.read()
            ver = re.search(
                r"ipx::package_project .*? -version (([0-9]*[.])?[0-9]+)", content
            ).group(1)
            current_versions[component] = float(ver)

    for component in components:
        if current_versions[component] > comp_versions[component]:
            print(
                f"Updating {component} from {comp_versions[component]} to {current_versions[component]}"
            )

            # Run the tcl script to update the IP
            code = subprocess.call(
                "bash -c '. ~/tools/Xilinx/Vivado/2024.1/settings64.sh && vivado -mode batch -source {component}/create_ip.tcl'".format(
                    component=component
                ),
                shell=True,
                stdout=sys.stdout,
                stderr=sys.stderr,
            )

            if code != 0:
                print(f"Error: Failed to update {component}.")
            else:
                comp_versions[component] = current_versions[component]

    with open("versions.txt", "w") as f:
        for component in components:
            f.write(f"{component}:{comp_versions[component]}\n")
