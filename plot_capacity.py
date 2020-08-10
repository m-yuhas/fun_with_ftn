#!/usr/bin/env python
"""Generate capacity plots from "Capacity Analysis of Faster-Than-Nyquist MIMO
Systems" and "On the Capacity of Faster-than-Nyquist MIMO Transmission with
CSI at the Receiver."""


from matplotlib import pyplot
import numpy


import simulate_capacity


def thesis_figure_6() -> None:
    snrs = numpy.array(list(range(-5, 25, 5)))
    line_styles = ['+-r', 'o-g', '*-b', 'x-c', 's-m', '+-y', 'o-c', '*-r',
                   'x-g', 's-b']
    plot = pyplot.subplot(111)
    for index, n_antenna in enumerate(range(1,11)):
        plot.plot(
            snrs,
            simulate_capacity.mimo_csir_capacity(
                n_antenna,
                n_antenna,
                1000,
                snrs),
            line_styles[index],
            markerfacecolor='none')
    plot.spines['right'].set_visible(False)
    plot.spines['top'].set_visible(False)
    pyplot.ylabel('Capacity (Bits / Sec / Hz)')
    pyplot.xlabel('SNR (dB)')
    pyplot.legend(['SISO', '2x2 MIMO', '3x3 MIMO', '4x4 MIMO', '5x5 MIMO',
                   '6x6 MIMO', '7x7 MIMO', '8x8 MIMO', '9x9 MIMO',
                   '10x10 MIMO'])
    pyplot.show()


if __name__ == '__main__':
    thesis_figure_6()
