// Password strength meter v2.0
// Matthew R. Miller - 2007
// www.codeandcoffee.com

// Settings
// -- Toggle to true or false, if you want to change what is checked in the password
var m_strUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var m_strLowerCase = "abcdefghijklmnopqrstuvwxyz";
var m_strNumber = "0123456789";
var m_strCharacters = "!@#$%^&*?_~"

// Check password
function checkPassword(strPassword)
{
        // Reset combination count
        var nScore = 0;

        // Password length
        // -- Less than 4 characters
        if (strPassword.length < 5)
        {
                nScore += 5;
        }
        // -- 5 to 7 characters
        else if (strPassword.length > 4 && strPassword.length < 8)
        {
                nScore += 10;
        }
        // -- 8 or more
        else if (strPassword.length > 7)
        {
                nScore += 25;
        }

        // Letters
        var nUpperCount = countContain(strPassword, m_strUpperCase);
        var nLowerCount = countContain(strPassword, m_strLowerCase);
        var nLowerUpperCount = nUpperCount + nLowerCount;
        // -- Letters are all lower case
        if (nUpperCount == 0 && nLowerCount != 0) 
        { 
                nScore += 10; 
        }
        // -- Letters are upper case and lower case
        else if (nUpperCount != 0 && nLowerCount != 0) 
        { 
                nScore += 20; 
        }

        // Numbers
        var nNumberCount = countContain(strPassword, m_strNumber);
        // -- 1 number
        if (nNumberCount == 1)
        {
                nScore += 10;
        }
        // -- 3 or more numbers
        if (nNumberCount >= 3)
        {
                nScore += 20;
        }

        // Characters
        var nCharacterCount = countContain(strPassword, m_strCharacters);
        // -- 1 character
        if (nCharacterCount == 1)
        {
                nScore += 10;
        }
        // -- More than 1 character
        if (nCharacterCount > 1)
        {
                nScore += 25;
        }

        // Bonus
        // -- Letters and numbers
        if (nNumberCount != 0 && nLowerUpperCount != 0)
        {
                nScore += 2;
        }
        // -- Letters, numbers, and characters
        if (nNumberCount != 0 && nLowerUpperCount != 0 && nCharacterCount != 0)
        {
                nScore += 3;
        }
        // -- Mixed case letters, numbers, and characters
        if (nNumberCount != 0 && nUpperCount != 0 && nLowerCount != 0 && nCharacterCount != 0)
        {
                nScore += 5;
        }


        return nScore;
}
 
// Runs password through check and then updates GUI 
function runPassword(strPassword, strFieldID) 
{
    // Check password
    var nScore = checkPassword(strPassword);

    // -- Very Secure
    if (nScore >= 90)
    {
        var attributes = {
            backgroundColor: { to: '#0ca908' },
            width: { to: 200 }
        };
    }
    // -- Secure
    else if (nScore >= 80)
    {
        var attributes = {
            backgroundColor: { to: '#7ff67c' },
            width: { to: 170 }
        };
    }
    // -- Very Strong
    else if (nScore >= 70)
    {
        var attributes = {
            backgroundColor: { to: '#1740ef' },
            width: { to: 140 }
        };
    }
    // -- Strong
    else if (nScore >= 60)
    {
        var attributes = {
            backgroundColor: { to: '#5a74e3' },
            width: { to: 110 }
        };
    }
    // -- Average
    else if (nScore >= 50)
    {
        var attributes = {
            backgroundColor: { to: '#e3cb00' },
            width: { to: 80 }
        };
    }
    // -- Weak
    else if (nScore >= 25)
    {
        var attributes = {
            backgroundColor: { to: '#e7d61a' },
            width: { to: 65 }
        };
    }
    // -- Very Weak
    else
    {
        var attributes = {
            backgroundColor: { to: '#e71a1a' },
            width: { to: 50 }
        };
    }
    var anim = new YAHOO.util.ColorAnim(strFieldID, attributes);
    anim.animate();
}
 
// Checks a string for a list of characters
function countContain(strPassword, strCheck)
{ 
        // Declare variables
        var nCount = 0;

        for (i = 0; i < strPassword.length; i++) 
        {
                if (strCheck.indexOf(strPassword.charAt(i)) > -1) 
                { 
                        nCount++;
                } 
        } 
 
        return nCount; 
} 
