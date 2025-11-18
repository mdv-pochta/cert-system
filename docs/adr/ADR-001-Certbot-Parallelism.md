# ADR-001: Certbot Parallelism Strategy

## Status
ACCEPTED

## Context
Certbot имеет глобальные блокировки. Нужно определить максимум параллельных процессов.

## Decision
Использовать 3-5 worker pool с семафором для контроля параллелизма.

## Rationale
- Testing показало, что 3-4 параллельных процесса работают без deadlock
- 5+ процессов начинают конфликтовать с file locks

## Consequences
- Max throughput: ~3-4 сертификата одновременно
- Остальные запросы ждут в queue
- Acceptable для 100 RPS load (распределяется по времени)
