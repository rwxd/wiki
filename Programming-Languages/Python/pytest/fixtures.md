# parameter to fixtures
```python
import json
import pytest

@pytest.fixture
def json_loader():
    """Loads data from JSON file"""

    def _loader(filename):
        with open(filename, 'r') as f:
            print(filename)
            data = json.load(f)
        return data

    return _loader


def test_wrong_stop(client, mocker, json_loader):
    # Arrange
    get_mock = mocker.MagicMock()
    get_mock.status_code = 200
    get_mock.json.return_value = json_loader(
        cta_error_incorrect_stop_response.json)
    mocker.patch.object(
        backend.cta.requests,
        'get',
        return_value=get_mock,
    )

    # Act
	response = client.simulate_get('/stops/106')

    # Assert
    assert response.status == falcon.HTTP_200
    assert response.json == {'error': 'stop_id: 106 does not exist
```