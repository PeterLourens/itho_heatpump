SELECT ID,
    DATE_FORMAT(
        (
            DATE(
                (
                    CONVERT_TZ(
                        (FROM_UNIXTIME(TIMESTAMP)),
                        'Etc/UTC',
                        'Europe/Amsterdam'
                    )
                )
            )
        ),
        '%M %Y'
    ) AS TIMESTAMP,
    YEAR(
        DATE(
            (
                CONVERT_TZ(
                    (FROM_UNIXTIME(TIMESTAMP)),
                    'Etc/UTC',
                    'Europe/Amsterdam'
                )
            )
        )
    ) AS YEAR,
    MONTH(
        DATE(
            (
                CONVERT_TZ(
                    (FROM_UNIXTIME(TIMESTAMP)),
                    'Etc/UTC',
                    'Europe/Amsterdam'
                )
            )
        )
    ) AS MONTH,
    SUM(kWh_used_high_tariff) AS kwh_used_high,
    SUM(kWh_used_low_tariff) AS kwh_used_low,
    SUM(kwh_ret_high_tariff) AS kwh_ret_high,
    SUM(kwh_ret_low_tariff) AS kwh_ret_low
FROM (
        SELECT ID,
            TIMESTAMP,
            LEAD(kwh_used_high) OVER(
                ORDER BY TIMESTAMP
            ) - kwh_used_high AS 'kWh_used_high_tariff',
            LEAD(kwh_used_low) OVER(
                ORDER BY TIMESTAMP
            ) - kwh_used_low AS 'kWh_used_low_tariff',
            LEAD(kwh_ret_high) OVER(
                ORDER BY TIMESTAMP
            ) - kwh_ret_high AS 'kWh_ret_high_tariff',
            LEAD(kwh_ret_low) OVER(
                ORDER BY TIMESTAMP
            ) - kwh_ret_low AS 'kWh_ret_low_tariff'
        FROM data
        WHERE YEAR(DATE(FROM_UNIXTIME(timestamp))) = YEAR('20211001')
    ) AS test
GROUP BY MONTH(FROM_UNIXTIME(TIMESTAMP))
ORDER BY MONTH(FROM_UNIXTIME(TIMESTAMP)) ASC