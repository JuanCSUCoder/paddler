Feature: Report llama.cpp metrics

    Background:
        Given balancer reports metrics every 100 milliseconds
        Given balancer is running
        Given statsd is running

    @serial
    Scenario: There is no agent attached
        Then average metrics are:
            | requests_buffered | 0 |
            | slots_idle        | 0 |
            | slots_processing  | 0 |

    @serial
    Scenario: There are multiple agents attached
        Given agent "agent-1" is running (has 1 slot)
        Given agent "agent-1" is registered
        Given agent "agent-2" is running (has 1 slot)
        Given agent "agent-2" is registered
        Then reported metrics are stored
        When multiple requests are sent to "/chat/completions"
            | req-1 |
            | req-2 |
            | req-3 |
            | req-4 |
            | req-5 |
        Then reported metrics are stored
        When multiple requests are sent to "/chat/completions"
            | req-6  |
            | req-7  |
            | req-8  |
            | req-9  |
            | req-10 |
        Then reported metrics are stored
        Then average metrics are:
            | slots_idle        | 1 |
            | slots_processing  | 1 |
            | requests_buffered | 0 |
