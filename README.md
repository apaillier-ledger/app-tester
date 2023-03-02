- Download boilerplate\_binaries.zip from a CI run : https://github.com/LedgerHQ/ragger/actions/workflows/build_and_tests.yml and place it alongside the Dockerfile
- Build the container : `docker build . -t app-tester:latest`
- Start it : `docker run --user "$(id -u):$(id -g)" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ -it app-tester:latest`
- Move into the Ragger local repository : `cd /tmp/ragger-develop/`
- Start the Ragger tests : `pytest -v --display --tb=short tests/ --cov ragger --cov-report xml --device all`