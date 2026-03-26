import re

LOG_PATTERN = re.compile(r'(?P<date>\S+ \S+) (?P<level>\S+) (?P<message>.*)')

def parse_log_file(filepath):
    parsed_logs = []

    with open(filepath, 'r') as file:
        for line in file:
            match = LOG_PATTERN.match(line)
            if match:
                parsed_logs.append(match.groupdict())

    return parsed_logs


def filter_by_level(logs, level):
    return [log for log in logs if log['level'] == level]