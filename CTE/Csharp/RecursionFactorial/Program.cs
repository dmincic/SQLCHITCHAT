using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RecursionFactorial
{
    class Program
    {
        static void Main(string[] args)
        {
            int Number = 0; 
            long Result;   

            //get arguments (get a number)
            if (args.Length != 0)
            {
                Number = Convert.ToInt32(args[0]);
            }

            Result = CalculateFactorial(Number); //call recursive function(method)

            Console.WriteLine("Factorial of number:{0} is: {1}" ,Number,Result);
            Console.ReadKey();
        }
        public static long CalculateFactorial(int number)
        {
            //n! = n x(n - 1) x(n - 2) x.... 1 ,   0! = 1

            //Termination check
            if (number == 0)
                return 1;

            //Recursive call
            return number * CalculateFactorial(number - 1);

        }
    }
}
