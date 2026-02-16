use std::path::PathBuf;

use clap::ArgMatches;
use eyre::{eyre, ErrReport};

pub enum Config {
    ResponseTimePercentile { percentile: f64, time_factor: u64, output_file: Option<PathBuf> },
    ThroughputOps { time_factor: u64, output_file: Option<PathBuf> },
}

impl TryFrom<ArgMatches> for Config {
    type Error = ErrReport;
    fn try_from(mut matches: ArgMatches) -> Result<Self, Self::Error> {
        match matches.get_flag("output-ops") {
            false => {
                let percentile = matches
                    .remove_one("percentile")
                    .ok_or(eyre!("Missing percentile"))?;
                let time_factor = matches
                    .remove_one("time-factor")
                    .ok_or(eyre!("Missing time-factor"))?;
                let output_file = matches.remove_one::<String>("output-file").map(|p| PathBuf::from(p));
                Ok(Config::ResponseTimePercentile {
                    percentile,
                    time_factor,
                    output_file
                })
            }
            true => {
                let time_factor = matches
                    .remove_one("time-factor")
                    .ok_or(eyre!("Missing time-factor"))?;
                let output_file = matches.remove_one::<String>("output-file").map(|p| PathBuf::from(p));
                Ok(Config::ThroughputOps { time_factor, output_file })
            }
        }
    }
}
