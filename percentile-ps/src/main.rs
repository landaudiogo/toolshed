use eyre::Result;

mod cli;
mod config;
mod program;

use config::Config;
use program::{response_time::PercentileResponseTime, throughput_ops::ThroughputOps};

fn main() -> Result<()> {
    let cmd = cli::register_args();
    let config = Config::try_from(cmd.get_matches())?;
    match config {
        Config::ResponseTimePercentile {
            percentile,
            time_factor,
            output_file,
        } => {
            PercentileResponseTime::run(time_factor, percentile, output_file);
        }
        Config::ThroughputOps { time_factor, output_file } => {
            ThroughputOps::run(time_factor, output_file);
        }
    }

    Ok(())
}
