package sudokuTask;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class task1b {

	public static void main(String[] args) throws FileNotFoundException {
		
		// Using the readFile method to load the sudoku grid into a 2D array.
		int[][] sudokuGrid = readFile("C:\\Users\\aaron\\OneDrive\\Documents\\Uni Work\\Year 3\\AI and Intelligence Agents\\Coursework 1\\Test-Sudoku.txt");
		
		// Testing to see if sudoku has been loaded correctly.
		for (int y = 0; y < 9; y++) {
			for (int x = 0; x < 9; x++) {
				System.out.print(sudokuGrid[y][x] + " ");
			}
			System.out.println();
		}

	}
	
	// Method to read the sudoku from a text file and store it in a 2D array.
	public static int[][] readFile (String filePath) throws FileNotFoundException{
		
		int[][] temporaryArray = new int[9][9]; // Temporary array to store the sudoku grid within the reading method.
		
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
	
}
