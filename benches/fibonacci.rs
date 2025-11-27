use std::time::Duration;

use criterion::{
    BenchmarkGroup, BenchmarkId, Criterion, criterion_group, criterion_main, measurement::WallTime,
};
use workflow_tests::{fibonacci_iterative, fibonacci_recursive};

fn bench(mut group: BenchmarkGroup<'_, WallTime>) {
    let n = 30;

    group.bench_function(BenchmarkId::new("iterative", n), |b| {
        b.iter(|| fibonacci_iterative(n))
    });

    group.bench_function(BenchmarkId::new("recursive", n), |b| {
        b.iter(|| fibonacci_recursive(n))
    });

    group.finish();
}

fn bench_fibonacci(c: &mut Criterion) {
    let mut group = c.benchmark_group("fibonacci");
    group
        .sample_size(100)
        .measurement_time(Duration::from_secs(7));

    bench(group);
}

criterion_group!(
    name = benches;
    config = Criterion::default();
    targets = bench_fibonacci
);
criterion_main!(benches);
