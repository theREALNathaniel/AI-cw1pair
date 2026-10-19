package sudokuTask;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class task1b {

	public static void main(String[] args) throws FileNotFoundException {
		
		// Using the readFile method to load the sudoku grid into a 2D array
		int[][] sudokuGrid = readFile("C:\\Users\\aaron\\OneDrive\\Documents\\Uni Work\\Year 3\\AI and Intelligence Agents\\Coursework 1\\Test-Sudoku.txt");
		
		solveSudoku(sudokuGrid);
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
	
	public static void solveSudoku(int[][] sudoku) {
		
		// Loading in the sudoku
		int[][] sudokuToSolve = sudoku;
		// Variable to keep track of if the assignment is invalid or not
		boolean invalid = false;
		
		// Looking at each square in the sudoku
		for (int row = 0; row < 9; row++) {
			for (int column = 0; column < 9; column++) {
				// Checking if the chosen square is empty
				if (sudokuToSolve[row][column] == 0) {
					// If it is, we try each value until it is not invalid
					for (int i = 1; i < 10; i++) {
						// Reset the invalid variable to false for each new number tried
						invalid = false;
						// Look down all the rows to see if the chosen number is repeated
						for (int r = 0; r < 9; r++) {
							// Skip over the row we are currently on
							if (row == r) {
								continue;
							}
							else {
								// Scenario if we encounter a duplicate element
								if (sudokuToSolve[r][column] == i) {
									// Set invalid to true so that we know that the current assignment is invalid
									invalid = true;
									// Break out of the loop as there is no need to check the other rows
									break;
								}
							}
						}
						// Checking to see if the assigned variable has already been flagged as invalid
						if (invalid == true) {
							// If this is the case, we move onto the next assignment
							continue;
						}
						else {
							// Looking through each column to see if there is a duplicate element
							for (int c = 0; c < 9; c++) {
								// Skipping over the column we have just assigned to
								if (column == c) {
									continue;
								}
								else {
									// Scenario if we found a duplicate element
									if (sudokuToSolve[row][c] == i) {
										// Flagging the element as invalid
										invalid = true;
										// Breaking out of the loop as we now know that the assigned element is invalid
										break;
									}
								}
							}
						}
						// Scenario if the current assignment is invalid, but there are more options
						if (invalid == true && i < 9) {
							// Move onto the next assignment
							continue;
						}
						// Scenario if the assignment is invalid, but there are no more options
						else if(invalid == true && i == 9) {
							// To be replaced with the backtrack method
							break;
						}
						// Scenario if the assignment is currently valid
						else {
							// Assign the square the valid value
							sudokuToSolve[row][column] = i;
							// Move on to the next square in the grid
							break;
						}
					}
				}
				// Checking to see if we have reached the last box in the sudoku
				if (row == 8 && column == 8) {
					// Checking to see if the final input is valid
					if (invalid == false) {
						// If it is, then the sudoku has been successfully solved
						System.out.println("The sudoku has been solved!");
						System.out.println();
						// We display the solved sudoku
						for (int r = 0; r < 8; r++) {
							for (int c = 0; c < 8; c++) {
								System.out.print(sudokuToSolve[r][c] + " ");
							}
							System.out.println();
						}
					}
					// Scenario if the sudoku has no solution
					else {
						System.out.println("The sudoku has no solution.");
					}
				}
			}
		}
		
	}
}
