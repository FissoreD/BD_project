
INSERT INTO carte_o VALUES (
    'silver',
    0.4,
    listrefclients_t()
);

INSERT INTO carte_o VALUES (
    'gold',
    0.4,
    listrefclients_t()
);

INSERT INTO carte_o VALUES (
    'bronze',
    0.2,
    listrefclients_t()
);

SELECT
    *
FROM
    carte_o oc
ORDER BY
    value(oc) DESC;
