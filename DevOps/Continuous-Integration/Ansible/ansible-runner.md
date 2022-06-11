# ansible-runner

## Usage

Run with docker as process isolation

`ansible-runner run demo -m debug --hosts localhost -a msg=hello --container-image quay.io/ansible/awx-ee -vvvv --process-isolation --process-isolation-executable=docker`

## Links
- [Using Runner with Execution Environments](https://ansible-runner.readthedocs.io/en/stable/execution_environments.html)
