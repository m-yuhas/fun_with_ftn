#!/usr/bin/env python
"""Generate capacity plots from "Capacity Analysis of Faster-Than-Nyquist MIMO
Systems" and "On the Capacity of Faster-than-Nyquist MIMO Transmission with
CSI at the Receiver."""


from matplotlib import pyplot
import numpy


import simulate_capacity


SNRS = numpy.array(list(range(-5, 25, 5)))


def thesis_figure_6() -> None:
    line_styles = ['+-r', 'o-g', '*-b', 'x-c', 's-m', '+-y', 'o-c', '*-r',
                   'x-g', 's-b']
    plot = pyplot.subplot(111)
    for index, n_antenna in enumerate(range(1,11)):
        plot.plot(
            SNRS,
            simulate_capacity.mimo_csir_capacity(
                nt=n_antenna,
                nr=n_antenna,
                iterations=1000,
                snrs=SNRS),
            line_styles[index],
            markerfacecolor='none')
    plot.spines['right'].set_visible(False)
    plot.spines['top'].set_visible(False)
    pyplot.ylabel('Capacity (Bits / Sec / Hz)')
    pyplot.ylim(0, 60)
    pyplot.xlabel('SNR (dB)')
    pyplot.legend(['SISO', '2x2 MIMO', '3x3 MIMO', '4x4 MIMO', '5x5 MIMO',
                   '6x6 MIMO', '7x7 MIMO', '8x8 MIMO', '9x9 MIMO',
                   '10x10 MIMO'])
    pyplot.show()


def thesis_figure_7() -> None:
    line_styles = ['+-r', 'o-g', '*-b', 'x-c', 's-m', '+-y', 'o-c', '*-r',
                   'x-g', 's-b']
    plot = pyplot.subplot(111)
    for index, n_antenna in enumerate(range(1,11)):
        plot.plot(
            SNRS,
            simulate_capacity.mimo_csir_capacity(
                nt=n_antenna,
                nr=1,
                iterations=1000,
                snrs=SNRS),
            line_styles[index],
            markerfacecolor='none')
    plot.spines['right'].set_visible(False)
    plot.spines['top'].set_visible(False)
    pyplot.ylabel('Capacity (Bits / Sec / Hz)') 
    pyplot.ylim(0, 7)
    pyplot.xlabel('SNR (dB)')
    pyplot.legend(['SISO', '2x1 MIMO', '3x1 MIMO', '4x1 MIMO', '5x1 MIMO',
                   '6x1 MIMO', '7x1 MIMO', '8x1 MIMO', '9x1 MIMO',
                   '10x1 MIMO'])
    pyplot.show()


def thesis_figure_8() -> None:
    line_styles = ['+-r', 'o-g', '*-b', 'x-c', 's-m', '+-y', 'o-c', '*-r',
                   'x-g', 's-b']
    plot = pyplot.subplot(111)
    for index, n_antenna in enumerate(range(1, 11)):
        plot.plot(
            SNRS,
            simulate_capacity.mimo_csir_capacity(
                nt=1,
                nr=n_antenna,
                iterations=1000,
                snrs=SNRS),
            line_styles[index],
            markerfacecolor='none')
    plot.spines['right'].set_visible(False)
    plot.spines['top'].set_visible(False)
    pyplot.ylabel('Capacity (Bits / Sec / Hz)')
    pyplot.ylim(0, 12)
    pyplot.xlabel('SNR (dB)')
    pyplot.legend(['SISO', '1x2 MIMO', '1x3 MIMO', '1x4 MIMO', '1x5 MIMO',
                   '1x6 MIMO', '1x7 MIMO', '1x8 MIMO', '1x9 MIMO',
                   '1x10 MIMO'])
    pyplot.show()


def thesis_figure_9() -> None:
    line_styles = ['+-r', 'o-g', '*-b', 'x-c']
    system_configs = [(1, 1), (1, 2), (2, 1), (2, 2)]
    plot = pyplot.subplot(111)
    for index, config in enumerate(system_configs):
            plot.plot(
                SNRS,
                simulate_capacity.mimo_csir_capacity(
                    nt=config[0],
                    nr=config[1],
                    iterations=1000,
                    snrs=SNRS),
                line_styles[index],
                markerfacecolor='none')
    plot.spines['right'].set_visible(False)
    plot.spines['top'].set_visible(False)
    pyplot.ylabel('Capcity (Bits / Sec / Hz)')
    pyplot.ylim(0, 14)
    pyplot.xlabel('SNR (dB)')
    pyplot.legend(['SISO', '1x2 MIMO', '2x1 MIMO', '2x2 MIMO'])
    pyplot.show()


if __name__ == '__main__':
    #thesis_figure_6()
    #thesis_figure_7()
    #thesis_figure_8()
    thesis_figure_9()
