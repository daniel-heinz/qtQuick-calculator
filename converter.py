import json

import requests


class ConverterBase:
    def get_supported(self):
        pass

    def conversion_rate(self, src, target):
        pass

    def convert(self, src, target, value):
        pass


class CurrencyConverter(ConverterBase):
    # alternative https://exchangeratesapi.io/
    exchange_service = 'https://data.fixer.io/latest'
    access_key = 'your-key-here'
    currencies = []
    exchange_rates = []

    def __init__(self):
        self.currencies = json.load(open('data/currencies.json'))
        self.exchange_rates = json.load(open('data/exchangerates.json'))

    def get_supported(self):
        return self.currencies

    def conversion_rate(self, src, target):
        if src not in self.currencies or target not in self.currencies:
            raise ValueError('Ether {0} or {1} currency is not supported.'.format(src, target))

        if src == target:
            return 1.0
        else:
            return self.exchange_rates[src]['rates'][target]

    def try_update_exchange(self):
        params = 'access_key={0}&base={1}&symbols={2}'
        changed = False

        for curr in self.exchange_rates.keys():
            symbols = ','.join(self.exchange_rates[curr]['rates'].keys())
            new_data = requests.get(self.exchange_service,
                                    params.format(self.access_key, curr, symbols)).json()
            if new_data['date'] > self.exchange_rates[curr]['date']:
                self.exchange_rates[curr] = new_data
                changed = True

        if changed:
            with open('data/exchangerates.json', 'w') as out:
                json.dump(self.exchange_rates, out, indent=2, sort_keys=True)

    def convert(self, src, target, value):
        return value * self.conversion_rate(src, target)


class DistanceConverter(ConverterBase):
    dist_units = []

    def __init__(self):
        self.dist_units = json.load(open('data/distances.json'))

    def get_supported(self):
        return self.dist_units

    def rate(self, unit):
        if unit not in self.dist_units:
            raise ValueError('Distance unit ({0}) is not supported'.format(unit))

        return self.dist_units[unit]['rate']

    def conversion_rate(self, src, target):
        return self.rate(src) / self.rate(target)

    def convert(self, src_unit, to_unit, value):
        return value * self.conversion_rate(src_unit, to_unit)


class SpeedConverter(ConverterBase):
    speed_units = []

    def __init__(self):
        self.speed_units = json.load(open('data/speeds.json'))

    def get_supported(self):
        return self.speed_units

    def rate(self, unit):
        if unit not in self.speed_units:
            raise ValueError('Speed unit ({0}) is not supported'.format(unit))

        return self.speed_units[unit]['rate']

    def conversion_rate(self, src, target):
        return self.rate(src) / self.rate(target)

    def convert(self, src_unit, to_unit, value):
        return value * self.conversion_rate(src_unit, to_unit)
