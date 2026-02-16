use std::{fs::File, io::{self, stdout, Write}, path::PathBuf};

pub struct ThroughputOps {}

impl ThroughputOps {
    pub fn run(time_factor: u64, output_file: Option<PathBuf>) {
        let mut end_times = Vec::new();

        println!("Reading input");
        for (i, line) in io::stdin().lines().enumerate() {
            let line = match line {
                Ok(c) => {
                    if c.len() == 0 {
                        break;
                    } else {
                        c
                    }
                }
                Err(_) => break,
            };

            if i % 500_000 == 0 {
                println!("Read {:?} lines", i)
            }

            let line = line.trim();
            let mut elements = line.split(",");

            let end = elements.nth(1).unwrap();
            match end.parse::<u64>() {
                Ok(end) => {
                    end_times.push(end);
                }
                Err(e) => {
                    eprintln!("{e}");
                    eprintln!("Element: {:?}", end);
                    panic!();
                }
            }
        }


        let mut buf: Box<dyn Write> = match output_file {
            Some(path) => { Box::new(File::create(path).unwrap()) }
            None => { Box::new(stdout()) }
        };
        writeln!(buf, "Epoch (s),Response Time (s)");

        end_times.sort();
        let (start, end) = (end_times[0], end_times[end_times.len() - 1]);

        for second in (start..end).step_by(time_factor as usize) {
            let first = end_times.partition_point(|x| x < &second);
            let last = end_times.partition_point(|x| x <= &(second + time_factor));
            writeln!(buf, "{},{}", second / time_factor, last - first);
        }
    }
}
