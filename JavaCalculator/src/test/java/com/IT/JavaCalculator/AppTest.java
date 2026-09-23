package com.IT.JavaCalculator;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

/**
 * Unit test for simple App.
 */
public class AppTest {
	Calculator a=new Calculator();
	@ParameterizedTest
	@CsvSource({
		"5,2,3",
		"10,5,5",
		"20,7,13",
		"7,2,5",
		"2,7,-5",
		"100,50,50"
	})
    public void t(int x,int y,int z) {
        assertEquals(z, a.subtract(x, y));
    }
}
