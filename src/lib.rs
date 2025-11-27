/// Calculate the `n`th Fibonacci number iteratively.
pub fn fibonacci_iterative(n: u32) -> u64 {
    if n < 2 {
        return n as u64;
    }

    let mut a = 0;
    let mut b = 1;
    let mut result = 0;

    for _ in 2..=n {
        result = a + b;
        a = b;
        b = result;
    }

    result
}

/// Calculate the `n`th Fibonacci number recursively without memoization.
pub fn fibonacci_recursive(n: u32) -> u64 {
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn calculates_fibonacci_iteratively() {
        assert_eq!(fibonacci_iterative(0), 0);
        assert_eq!(fibonacci_iterative(1), 1);
        assert_eq!(fibonacci_iterative(2), 1);
        assert_eq!(fibonacci_iterative(3), 2);
        assert_eq!(fibonacci_iterative(4), 3);
        assert_eq!(fibonacci_iterative(5), 5);
        assert_eq!(fibonacci_iterative(6), 8);
        assert_eq!(fibonacci_iterative(7), 13);
        assert_eq!(fibonacci_iterative(8), 21);
        assert_eq!(fibonacci_iterative(9), 34);
        assert_eq!(fibonacci_iterative(10), 55);
    }

    #[test]
    fn calculates_fibonacci_recursively() {
        assert_eq!(fibonacci_recursive(0), 0);
        assert_eq!(fibonacci_recursive(1), 1);
        assert_eq!(fibonacci_recursive(2), 1);
        assert_eq!(fibonacci_recursive(3), 2);
        assert_eq!(fibonacci_recursive(4), 3);
        assert_eq!(fibonacci_recursive(5), 5);
        assert_eq!(fibonacci_recursive(6), 8);
        assert_eq!(fibonacci_recursive(7), 13);
        assert_eq!(fibonacci_recursive(8), 21);
        assert_eq!(fibonacci_recursive(9), 34);
        assert_eq!(fibonacci_recursive(10), 55);
    }
}
