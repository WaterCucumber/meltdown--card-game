using System;
using Godot;


/// <summary>
/// Class that represents visualization of currency; use this class for displaying data
/// </summary>
[GlobalClass]
public partial class CurrencyType : Resource
{
    public enum Type
    {
        ActionPoints,  
        Radiation,  
        Temperature,  
        Energy,  
        SafetyPoints,  
        VictoryPoints,
        Difficulty,
    }
    /// <summary>
    /// Useful replaces: <c>/v -> Currency.value</c> 
    /// <para><c>/i -> this.texture</c></para>
    /// <para><c>/l -> '/ Currency.limit'</c></para>
    /// <para><c>/d -> Currency.pending_value</c> (<i>With Plus Sign</i>)</para>
    /// <para><c>/d!s -> Currency.pending_value</c> (<i>Without Plus Sign</i>)</para>
    /// </summary>
    [Export] public string placeholder_text = "/v/i /l (/d/i)";
    [Export(PropertyHint.File, "*.png")] public string texture;
    [Export] public bool positive;
    /// <summary>
    /// if less than or equals to 0, limit = inf
    /// </summary>
    [Export] public float limit = 0;
    [Export] public float floor_coef = 1;
    [Export] public bool use_buff = false;
    [Export] public float buff_influence = 1;


    public string get_text(Currency currency, int size = 16)
    {
        string result = placeholder_text;
        float lim = floor_coef == 1 ? Mathf.FloorToInt(limit) : Mathf.Floor(limit * floor_coef) / floor_coef;
        if (currency != null) 
        {
            float v = floor_coef == 1 ? Mathf.FloorToInt(currency.Value) : Mathf.Floor(currency.Value * floor_coef) / floor_coef;
            float pending_value = floor_coef == 1 ? Mathf.FloorToInt(currency.pending_value) : Mathf.Floor(currency.pending_value * floor_coef) / floor_coef;
            result = result.Replace("/v", v.ToString());
            result = result.Replace("/d!s", get_colored_value(pending_value, false));
            result = result.Replace("/d", get_colored_value(pending_value));
        }
        result = result.Replace("/i", $"[img=,{size}]{texture}[/img]");
        result = result.Replace("/l", "/ " + lim.ToString());
        return result;
    }

    private string get_colored_value(float v, bool withSign = true)
    {
        string sign = !withSign || v < 0 ? "" : "+";
        Color color = v == 0 ? Colors.Gray
                : v > 0 && positive || v < 0 && !positive ? Colors.Green 
                : Colors.Red;
        string strValue = $"[color={color.ToHtml(false)}]{sign}{v}[/color]";
        return strValue;
    }

    public override string ToString()
    {
        return get_text(null);
    }

}
