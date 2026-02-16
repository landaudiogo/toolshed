#!/usr/bin/env python

from typing import Optional
import pandas as pd
import click
from pathlib import Path

@click.command()
@click.option('--epoch-column', required=True, is_flag=False, metavar='<epoch-column>', type=click.STRING, help='The epoch column name')
@click.option('--epoch-unit', required=True, is_flag=False, metavar='<epoch-column>', type=click.STRING, help="The epoch column's units (e.g. s, us, ns) for pandas.to_datetime")
@click.option('--timestamp-column', default="Timestamp", is_flag=False, metavar='<rename-to>', type=click.STRING, help='The name that should be given to the timestamp column')
@click.option('--append', default=True, is_flag=True, help='Specify this option to preserve the epoch column')
@click.option("--output-file", required=False, default=None, type=click.Path(exists=False), help="File where to store the transformed DataFrame. If not provided, the input CSV_FILE path is used.")
@click.argument('csv-file', type=click.Path(exists=True))
def main(epoch_column: str, epoch_unit: str, timestamp_column: str, append: bool, csv_file: click.Path, output_file: Optional[click.Path]):
    """This command converts a CSV_FILE's epoch column to timestamp"""

    df = pd.read_csv(str(csv_file))
    if epoch_column not in df:
        ctx = click.get_current_context()
        click.echo(ctx.get_help())
        ctx.exit()

    df[timestamp_column] = pd.to_datetime(df[epoch_column], unit=epoch_unit, utc=True)
    if append == False: 
        df = df.drop(epoch_column, axis=1)

    if output_file is not None: 
        df.to_csv(str(output_file), index=False)
    else:
        df.to_csv(str(csv_file), index=False)

if __name__ == "__main__":
    main()
