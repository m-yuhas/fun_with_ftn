#!/usr/bin/env python
"""Capacity analysis of FTN MIMO systems."""


import csv


import numpy


SNR_MAX = 20
SNR_MIN = -5
SNR_INC = 5
ITERATIONS = 1000
NT_MAX = 4
NT_MIN = 1
NT_INC = 1
NR_MAX = 2
NR_MIN = 2
NR_INC = 1
FTN_MAX = 4
FTN_MIN = 1
FTN_INC = 1


def generate_channel(n_transmit: int,
                     n_receive: int,
                     ftn_streams: int,
                     packet_size: int,
                     fade_type: str) -> numpy.ndarray:
    """Generate a channel matrix for an FTN MIMO system.

    Args:
        n_transmit: number of transmitters
        n_receive: number of receivers
        ftn_streams: number of FTN streams
        packet_size: number of symbols in one FTN stream in one packet
        fade_type: 'rayleigh' or unitary 
    """
    row = numpy.zeros(ftn_streams * packet_size)
    row[0:ftn_streams] = numpy.arange(ftn_streams, 0, -1) / ftn_streams
    h_ftn = toeplitz(row)
    h_mimo = zeros(n_receive, n_transmit)
    return numpy.kron(h_ftn, h_mimo)


def toeplitz(row: numpy.ndarray) -> numpy.ndarray:
    horizontal = numpy.zeros((row.size, row.size))
    vertical = numpy.zeros((row.size, row.size))
    for i in range(row.size):
        horizontal[i,:] = numpy.roll(row, i)
        horizontal[i,0:i] = numpy.zeros(i)
        vertical[:,i] = numpy.roll(row, i)
        vertical[0:i,i] = numpy.zeros(i)
    return horizontal + vertical - numpy.identity(row.size)


def mimo_csir_capacity(nt: int,
                       nr: int,
                       iterations: int,
                       snrs: numpy.ndarray) -> numpy.ndarray:
    capacities = numpy.zeros(snrs.size)
    for i in range(iterations):
        channel_matrix = numpy.random.normal(loc=0, scale=1, size=(nr, nt))
        it = numpy.nditer(snrs, flags=['f_index'])
        for snr in it:
            sig_sq = 1 / (nt * numpy.power(10, snr / 10))
            capacities[it.index] += numpy.log2(
                numpy.linalg.det(
                    numpy.identity(nr) + ((10 ** (snr / 10)) / nt) * numpy.matmul(
                        channel_matrix, channel_matrix.conj().T)))
    return capacities / iterations



def mimo_csit_capacity(nt: int,
                       nr: int,
                       iterations: int,
                       snrs: numpy.ndarray) -> numpy.ndarray:
    capacities = numpy.zeros(snrs.size)
    for i in range(iterations):
        channel_matrix = numpy.random.normal(loc=0, scale=1, size=(nr, nt))
        _, s, _ = numpy.linalg.svd(channel_matrix)
        it = numpy.nditer(snrs, flags=['f_index']) 
        for snr in it:
            power_allocations = water_filling(s, snr)
            sig_sq = 1 / (numpy.power(10, snr / 10))
            capacities[it.index] += numpy.sum(
                numpy.log2(1 + (s ** 2) * power_allocations / sig_sq))
    return capacities / iterations


def ftn_capacity(ftn_streams: int,
                 packet_size: int,
                 snrs: numpy.ndarray) -> numpy.ndarray:
    row = numpy.zeros(ftn_streams * packet_size)
    row[0:ftn_streams] = numpy.arange(ftn_streams, 0, -1) / ftn_streams
    channel_matrix = (1 / numpy.sqrt(ftn_streams)) * toeplitz(row)
    return (1 / packet_size) * numpy.log2(numpy.linalg.det(
        numpy.identity(row.size) + (channel_matrix * numpy.power(10, snr / 10))))


def water_filling(singular_values: numpy.ndarray,
                  snr: float) -> numpy.ndarray:
    sig_sq = 1 / (numpy.power(10, snr / 10))
    singular_values.sort()
    power_allocation = numpy.zeros(singular_values.size)
    for i, sig_i in enumerate(singular_values):
        water_level = (1 + sig_sq * numpy.sum(1 / singular_values[i:] ** 2)) \
            / (singular_values.size - i)
        if water_level - (sig_sq / (sig_i ** 2)) >= 0:
            power_allocation[i:] = water_level - \
                (sig_sq / (singular_values[i:] ** 2))
            return power_allocation 


def simulate_capacity(save_file: str) -> None:
    capacity = numpy.zeros((
        numpy.ceil((SNR_MAX - SNR_MIN + 1) / SNR_INC),
        numpy.ceil((NT_MAX - NT_MIN + 1) / NT_INC),
        numpy.ceil((FTN_MAX - FTN_MIN + 1) / FTN_INC)))


if __name__ == '__main___':
    simulate_capacity()
