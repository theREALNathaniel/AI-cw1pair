package sudokuTask;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class task1b {
	
	// Global variable to keep track of the number of times the program has backtracked to try and solve the sudoku
	static int numberOfBacktracks = 0;

	public static void main(String[] args) throws FileNotFoundException {
		
		// Timer call at the start of the program
		long startTime = System.nanoTime();
		
		// Using the readFile method to load the sudoku grid into a 2D array
		int[][] sudokuGrid = readFile("C:\\Users\\aaron\\OneDrive\\Documents\\Uni Work\\Year 3\\AI and Intelligence Agents\\Coursework 1\\Hard-Sudoku.txt");
		
		// Scenario if the sudoku has been solved
		if (solveSudoku(sudokuGrid) == true) {
			// Tell the user the sudoku has been solved
			System.out.println("The sudoku has been solved!");
			// Display the solved sudoku
			for (int row = 0; row < 9; row++) {
				for (int column = 0; column < 9; column++) {
					System.out.print(sudokuGrid[row][column] + " ");
				}
				System.out.println();
			}
		}
		// Scenario if the sudoku has no solution
		else {
			System.out.println("The sudoku has no solution.");
		}
		
		// Timer call after the program has ran
		long endTime = System.nanoTime();
		
		// Calculate the runtime and change it into milliseconds rather than nanoseconds
		double executionTime  = (endTime - startTime) / 1000000;
		
		// Displaying the runtime. 
		System.out.println();
		System.out.println("Execution time: " + executionTime + " milliseconds");
		System.out.println("Number of backtracks: " + numberOfBacktracks);
		
	}
	
	// Method to read the sudoku from a text file and store it in a 2D array
	public static int[][] readFile (String filePath) throws FileNotFoundException{
		
		int[][] temporaryArray = new int[9][9]; // Temporary array to store the sudoku grid within the reading method
		
		Scanner input = new Scanner(new File(filePath));
		
		for (int row = 0; row < 9; row++) {
			String line = input.nextLine();
			String[] values = line.split(",");
			
			for (int column = 0; column < 9; column++) {
				temporaryArray[row][column] = Integer.parseInt(values[column].trim());
			}
		}
		
		input.close();
		
		return temporaryArray;
		
	}
	
	// Method to solve the sudoku
	public static boolean solveSudoku(int[][] sudoku) {
		
		// Finding an empty square
		for (int row = 0; row < 9; row++) {
			for (int column = 0; column < 9; column++) {
				// Checking that the square is empty
				if (sudoku[row][column] == 0) {
					// Looping through each value and trying it in the square to see if it is valid or not
					for (int i = 1; i < 10; i++) {
						// Using the method isValid to check if the assignment is valid or not
						if (isValid(sudoku, row, column, i) == true) {
							// If it is, we assign this value to the sudoku square
							sudoku[row][column] = i;
							// We now recursively solve the remaining squares, but we check at the same time that we do not need to backtrack
							if (solveSudoku(sudoku) == true) {
								return true;
							}
							else {
								// Since we can't solve the sudoku from this allocation, we backtrack and change reset its value to 0
								sudoku[row][column] = 0;
								numberOfBacktracks += 1;
							}
						}
					}
					// Return false if all values have been tried but none are successful
					return false;
				}
			}
		}
		
		// Scenario when we have looked through all the squares and no empty squares remain
		return true;
		
	}
	
	// Method to validate an assignment
	public static boolean isValid(int[][] sudoku, int r, int c, int value) {
		
		// Checking the rows and columns to see if there is a clash
		for (int count = 0; count < 9; count++) {
			// Scenario if there is a duplicate element in the rows
			if (sudoku[r][count] == value) {
				return false;
			}
			// Scenario if there is a duplicate element in the columns
			if (sudoku[count][c] == value) {
				return false;
			}
		}
		
		// Now check the 3 x 3 boxes,
		
		// Calculating the top left square of the 3 x 3 box
		int boxRow = (r / 3) * 3;
		int boxColumn = (c / 3) * 3;
		
		// Checking each square in the 3 x 3 box for duplicate values
		for (int y = boxRow; y < boxRow + 3; y++) {
			for (int x = boxColumn; x < boxColumn + 3; x++) {
				// Scenario if a duplicate value has been found
				if (sudoku[y][x] == value) {
					return false;
				}
			}
		}
		
		// Returning true if no duplicates have been found, meaning the assigned value is valid
		return true;
		
	}
	
}
