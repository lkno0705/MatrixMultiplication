#![allow(non_snake_case)]

use std::cell::UnsafeCell;
use std::sync::Arc;
use std::time::Instant;

extern crate num_cpus;
extern crate rand;
extern crate rayon;

use rand::Rng;

fn matmul(c: &mut [f32], b: &[f32], a: &[f32], n: usize, m: usize, p: usize) {
    assert!(c.len() == m * p);
    assert!(b.len() == n * p);
    assert!(a.len() == m * n);
    for i in 0..m {
        for k in 0..p {
            let mut sum = 0.;
            for j in 0..n {
                sum += a[n * i + j] * b[p * j + k];
            }
            c[p * i + k] = sum;
        }
    }
}

fn par_matmul_inner(
    c: &mut [f32],
    b: &[f32],
    a: &[f32],
    n: usize,
    m: usize,
    p: usize,
    upper: usize,
    lower: usize,
) {
    assert!(c.len() == m * p);
    assert!(b.len() == n * p);
    assert!(a.len() == m * n);
    for i in lower..upper {
        for k in 0..p {
            let mut sum = 0.;
            for j in 0..n {
                sum += a[n * i + j] * b[p * j + k];
            }
            c[p * i + k] = sum;
        }
    }
}

#[derive(Debug)]
struct Wrapper {
    pub data: UnsafeCell<Vec<f32>>,
}

unsafe impl Sync for Wrapper {}

fn par_matmul(
    c: Vec<f32>,
    b: &[f32],
    a: &[f32],
    n: usize,
    m: usize,
    p: usize,
    threads: usize,
) -> Vec<f32> {
    let step = m / threads;
    assert_eq!(c.len(), m * p);
    let c = Arc::new(Wrapper {
        data: UnsafeCell::new(c),
    });
    let _ = rayon::scope(|scope| unsafe {
        let a = UnsafeCell::new(a);
        let b = UnsafeCell::new(b);
        let c = Arc::clone(&c);
        for i in 0..threads {
            let lower = i * step;
            let upper = if i != (threads - 1) {
                (i + 1) * step
            } else {
                m
            };
            let c = c.data.get().as_mut().unwrap();
            let b = *b.get();
            let a = *a.get();
            scope.spawn(move |_| {
                par_matmul_inner(c, b, a, n, m, p, upper, lower);
            });
        }
    });
    return Arc::try_unwrap(c)
        .expect("someone holds our data")
        .data
        .into_inner();
}

fn main() {
    let n = 1440;
    let m = 1440;
    let p = 1440;
    let print = false;
    let threads = num_cpus::get();

    let mut c = Vec::with_capacity(m * p);
    for _ in 0..(m * p) {
        c.push(0f32);
    }
    let mut a = Vec::with_capacity(n * m);
    let mut b = Vec::with_capacity(n * p);
    let mut rng = rand::thread_rng();
    for _ in 0..(n * m) {
        a.push(rng.gen_range(0f32, 1f32));
    }
    for _ in 0..(n * p) {
        b.push(rng.gen_range(0f32, 1f32));
    }

    let now = Instant::now();
    matmul(&mut c, &b, &a, n, m, p);
    let millis = now.elapsed().as_millis() as f32 / 1000.;
    println!("Singlethreaded took {}s", millis);
    let now = Instant::now();
    let c = par_matmul(c, &b, &a, n, m, p, threads);
    let millis = now.elapsed().as_millis() as f32 / 1000.;
    println!("Multithreaded took {}s", millis);
    if print {
        for x in c {
            print!("{} ", x);
        }
    }
}
