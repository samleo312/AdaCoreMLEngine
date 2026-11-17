"""Plot CSV output from the spiral demo.

Run the demo first, then run this script from the same directory. Alternatively,
pass --data-dir PATH. Requires numpy and matplotlib.
"""

import argparse
import csv
from pathlib import Path

import matplotlib
import numpy as np

matplotlib.use("Agg")

import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib.lines import Line2D


parser = argparse.ArgumentParser(description="Plot the spiral demo CSV files.")
parser.add_argument(
    "--data-dir",
    type=Path,
    default=Path.cwd(),
    help="Directory containing the CSV files (default: current directory)",
)
p = parser.parse_args().data_dir

with (p / "spiral_samples.csv").open() as f:
    samples = list(csv.DictReader(f))

with (p / "spiral_grid.csv").open() as f:
    grid = list(csv.DictReader(f))

x = np.array([float(v["x"]) for v in samples])
y = np.array([float(v["y"]) for v in samples])
labels = np.array([int(v["label"]) for v in samples])
predicted = np.array([int(v["prediction"]) for v in samples])

gx = np.array([float(v["x"]) for v in grid])
gy = np.array([float(v["y"]) for v in grid])
gz = np.array([int(v["prediction"]) for v in grid])

n = len(np.unique(gx))
assert n * n == len(grid), "Expected a square prediction grid"

G = gz.reshape(n, n)
X = gx.reshape(n, n)
Y = gy.reshape(n, n)

colors = ["#2861a4", "#db7550", "#4d9978"]
light = ["#d6e7fa", "#fce2d8", "#d4eee0"]

fig, axs = plt.subplots(1, 2, figsize=(13.2, 7.4), facecolor="#f7f8fa")
fig.subplots_adjust(left=0.065, right=0.985, bottom=0.19, top=0.81, wspace=0.20)
fig.suptitle(
    "What the network learned",
    x=0.055,
    ha="left",
    fontsize=22,
    fontweight="bold",
    color="#182436",
)

axs[0].set_title("Training samples", loc="left", fontsize=14, weight="bold", pad=12)
axs[1].set_title("Learned decision regions", loc="left", fontsize=14, weight="bold", pad=12)
axs[1].pcolormesh(
    X, Y, G, cmap=ListedColormap(light), vmin=0.5, vmax=3.5,
    shading="nearest", rasterized=True,
)

for ax in axs:
    for k, c in enumerate(colors, 1):
        take = labels == k
        ax.scatter(
            x[take], y[take], s=24, c=c, edgecolor="white",
            linewidth=0.45, alpha=0.95, zorder=3,
        )

    ax.set(
        xlim=(-1.2, 1.2), ylim=(-1.2, 1.2),
        xlabel="Input feature 1", ylabel="Input feature 2",
    )
    ax.set_aspect("equal")
    ax.set_facecolor("white")
    ax.grid(alpha=0.13, color="#8795a5", linewidth=0.6)

    for spine in ax.spines.values():
        spine.set_color("#bdc6d1")

wrong = labels != predicted
axs[1].scatter(
    x[wrong], y[wrong], s=112, facecolors="none",
    edgecolors="#17212d", linewidths=1.3, zorder=4,
)

handles = [
    Line2D(
        [0], [0], marker="o", linestyle="", markerfacecolor=c,
        markeredgecolor="white", markersize=8, label=f"Class {i}",
    )
    for i, c in enumerate(colors, 1)
]
handles.append(
    Line2D(
        [0], [0], marker="o", linestyle="", markerfacecolor="none",
        markeredgecolor="#17212d", markersize=10, label="Incorrect prediction",
    )
)
fig.legend(
    handles=handles, loc="lower center", bbox_to_anchor=(0.5, 0.045),
    ncol=4, frameon=False, fontsize=10,
)

fig.text(
    0.055, 0.875, f"Three-class spiral  |  {len(labels)} training samples",
    fontsize=11, color="#576575",
)
fig.text(
    0.055, 0.105,
    f"Training accuracy: {(~wrong).sum()}/{len(labels)} ({100 * (~wrong).mean():.0f}%)"
    f"  |  Background: predicted class on a {n} x {n} grid.",
    fontsize=10, color="#576575",
)
fig.savefig(
    p / "spiral_decision_regions.png", dpi=190,
    bbox_inches="tight", facecolor=fig.get_facecolor(),
)

print(
    "samples", len(labels), "correct", (~wrong).sum(),
    "grid", len(grid), "counts", np.bincount(gz)[1:].tolist(),
)
